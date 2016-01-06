package com.tyrion.plugin.cropper;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

import com.tyrion.cropper.CropHandler;
import com.tyrion.cropper.CropHelper;
import com.tyrion.cropper.CropParams;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;

/**
 * This class echoes a string called from JavaScript.
 */
public class imageCropper extends CordovaPlugin implements CropHandler {

    public static final String TAG = "MainActivity";
    CropParams mCropParams;
    CallbackContext callback;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("crop")) {
            mCropParams = new CropParams();
            callback = callbackContext;
            int sourceType = args.getInt(0);
            JSONArray size = args.getJSONArray(1);
            int outputWidth = size.getInt(0);
            int outputHeight = size.getInt(1);
            Log.e("width", outputWidth + "");
            Log.e("height", outputHeight + "");

            mCropParams.refreshUri();
            mCropParams.enable = true;
            mCropParams.compress = false;
            mCropParams.aspectX = outputWidth;
            mCropParams.aspectY = outputHeight;
            mCropParams.outputX = outputWidth;
            mCropParams.outputY = outputHeight;

            Intent intent;
            int request;
            switch (sourceType){
                case 0:
                    intent = CropHelper.buildGalleryIntent(mCropParams);
                    request = CropHelper.REQUEST_CROP;
                    break;
                case 1:
                    intent = CropHelper.buildCameraIntent(mCropParams);
                    request = CropHelper.REQUEST_CAMERA;
                    break;
                default:
                    intent = CropHelper.buildGalleryIntent(mCropParams);
                    request = CropHelper.REQUEST_CROP;

            }
            this.cordova.startActivityForResult(this, intent, request);
            return true;
        }
        return false;
    }

    @Override
    public void onDestroy() {
        CropHelper.clearCacheDir();
        super.onDestroy();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.e(TAG, "onActivityResult");
        CropHelper.handleResult(this, requestCode, resultCode, data);
        if (requestCode == 1) {
            Log.e(TAG, "");
        }
    }

    @Override
    public void onPhotoCropped(Uri uri) {
        Log.d(TAG, "Crop Uri in path: " + uri.getPath());
        callback.success(uri.getPath());
    }

    @Override
    public void onCompressed(Uri uri) {
    }

    @Override
    public void onCancel() {
        Toast.makeText(this.cordova.getActivity(), "Crop canceled!", Toast.LENGTH_LONG).show();
    }

    @Override
    public void onFailed(String message) {
        Toast.makeText(this.cordova.getActivity(), "Crop failed: " + message, Toast.LENGTH_LONG).show();
    }

    @Override
    public void handleIntent(Intent intent, int requestCode) {
        this.cordova.startActivityForResult(this, intent, requestCode);
    }

    @Override
    public CropParams getCropParams() {
        return mCropParams;
    }
}

