from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token = Header()):
    try:
        if not x_auth_token:
            raise HTTPException(status_code=401, detail="Token is missing")
        
        verified_token = jwt.decode(x_auth_token, 'password_key', algorithms=['HS256'])

        if not verified_token:
            raise HTTPException(status_code=401, detail="Invalid token")
        
        uid = verified_token.get('id')
        return {'uid':uid, 'token': x_auth_token}
    
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")