import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final songArtistController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedAudio;
  File? selectedImage;
  final formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      // Handle the selected image file
      setState(() {
        selectedAudio = pickedAudio;
      });
    } else {}
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      // Handle the selected image file
      setState(() {
        selectedImage = pickedImage;
      });
    } else {}
  }

  @override
  void dispose() {
    songNameController.dispose();
    songArtistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((value) => value?.isLoading == true),
    );

    // TODO: The snackbar doesn't appear, fix it 
    // ref.listen(homeViewModelProvider, (_, next) {
    //   next?.when(
    //     data: (data) {
    //       showSnackBar(context, 'Song ${data.songName} uploaded successfully');
    //     },
    //     error: (error, stackTrace) {
    //       showSnackBar(context, error.toString());
    //     },
    //     loading: () {},
    //   );
    // });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewModelProvider.notifier)
                    .uploadSong(
                      songName: songNameController.text,
                      songArtist: songArtistController.text,
                      audioFile: selectedAudio!,
                      imageFile: selectedImage!,
                      selectedColor: selectedColor,
                    );
              } else {
                showSnackBar(context, 'Please fill all the fields');
              }
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const LoaderWidget()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 170,
                          width: double.infinity,
                          child: InkWell(
                            onTap: selectImage,
                            child:
                                selectedImage != null
                                    ? SizedBox(
                                      height: 170,
                                      width: double.infinity,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          selectedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                    : DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        radius: const Radius.circular(10),
                                        color: Pallete.borderColor,
                                        dashPattern: [10, 4],
                                        strokeWidth: 2,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.folder_open, size: 40),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Select the thumbnail for your Song',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            selectedAudio != null
                                ? AudioWave(audioPath: selectedAudio!.path)
                                : CustomField(
                                  hintText: 'Pick Song',
                                  controller: null,
                                  readOnly: true,
                                  onTap: () {
                                    selectAudio();
                                  },
                                ),
                            const SizedBox(height: 20),
                            CustomField(
                              hintText: 'Artist',
                              controller: songArtistController,
                            ),
                            const SizedBox(height: 20),
                            CustomField(
                              hintText: 'Song Name',
                              controller: songNameController,
                            ),
                            const SizedBox(height: 20),
                            ColorPicker(
                              pickersEnabled: const {
                                ColorPickerType.wheel: true,
                              },
                              color: selectedColor,
                              onColorChanged: (Color color) {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
