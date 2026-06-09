package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

public class CloudinaryUtil {

    private static Cloudinary cloudinary;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dnmowplwi",
                "api_key", "247133549794284",
                "api_secret", "Ty8jzGrhIRK7uqIjcTxoLCnVJkk",
                "secure", true
        ));
    }

    public static Cloudinary getInstance() {
        return cloudinary;
    }
}
