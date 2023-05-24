package com.amazon.flutter_amazonpaymentservices;

import static android.app.Activity.RESULT_CANCELED;
import static android.app.Activity.RESULT_OK;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.LabeledIntent;

import androidx.annotation.NonNull;

import com.payfort.fortpaymentsdk.FortSdk;
import com.payfort.fortpaymentsdk.callbacks.FortCallBackManager;
import com.payfort.fortpaymentsdk.callbacks.FortCallback;
import com.payfort.fortpaymentsdk.callbacks.FortInterfaces;
import com.payfort.fortpaymentsdk.callbacks.PayFortCallback;
import com.payfort.fortpaymentsdk.domain.model.FortRequest;
import com.payfort.fortpaymentsdk.domain.model.SdkResponse;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterAmazonpaymentservicesPlugin
 */
public class FlutterAmazonpaymentservicesPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String METHOD_CHANNEL_KEY = "flutter_amazonpaymentservices";
    private static final int PAYFORT_REQUEST_CODE = 1166;
    static FortCallBackManager fortCallback;
    private MethodChannel methodChannel;
    private static Activity activity;
    private Constants.ENVIRONMENTS_VALUES mEnvironment;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel = new MethodChannel(binding.getBinaryMessenger(), METHOD_CHANNEL_KEY);
        methodChannel.setMethodCallHandler(this);

    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL_KEY);
        FlutterAmazonpaymentservicesPlugin handler = new FlutterAmazonpaymentservicesPlugin();
        handler.methodChannel = channel;
        activity = registrar.activity();
        channel.setMethodCallHandler(handler);

        registrar.addActivityResultListener((requestCode, resultCode, data) -> {
            if (requestCode == PAYFORT_REQUEST_CODE )
                if(data!=null && resultCode == RESULT_OK)
                    fortCallback.onActivityResult(requestCode, resultCode, data);
                else{
                    Intent intent = new Intent();
                    intent.putExtra("","");
                    fortCallback.onActivityResult(requestCode, resultCode, intent);
                }
            return true;
        });

    }


    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "normalPay":
                handleOpenFullScreenPayfort(call, result);
                break;
            case "getUDID":
                result.success(FortSdk.getDeviceId(activity));
                break;
            case "validateApi":
                handleValidateAPI(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener((requestCode, resultCode, data) -> {
            if (requestCode == PAYFORT_REQUEST_CODE )
                if(data!=null && resultCode == RESULT_OK)
                fortCallback.onActivityResult(requestCode, resultCode, data);
                else{
                    Intent intent = new Intent();
                    intent.putExtra("","");
                    fortCallback.onActivityResult(requestCode, resultCode, intent);
                }
                return true;
            });

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        methodChannel.setMethodCallHandler(null);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener((requestCode, resultCode, data) -> {
            if (requestCode == PAYFORT_REQUEST_CODE )
                if(data!=null && resultCode == RESULT_OK)
                    fortCallback.onActivityResult(requestCode, resultCode, data);
                else{
                    Intent intent = new Intent();
                    intent.putExtra("","");
                    fortCallback.onActivityResult(requestCode, resultCode, intent);
                }
            return true;
        });

    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;

    }

    private void handleValidateAPI(MethodCall call, Result result) {
        if (call.argument("environmentType").toString().equals("production"))
            mEnvironment = Constants.ENVIRONMENTS_VALUES.PRODUCTION;
        else
            mEnvironment = Constants.ENVIRONMENTS_VALUES.SANDBOX;

        HashMap<String, Object> requestParamMap = call.argument("requestParam");
        FortRequest fortRequest = new FortRequest();
        fortRequest.setRequestMap(requestParamMap);
        FortSdk.getInstance().validate(activity, FortSdk.ENVIRONMENT.TEST, fortRequest, new PayFortCallback() {
            @Override
            public void startLoading() {

            }

            @Override
            public void onSuccess(@NonNull Map<String, ?> fortResponseMap, @NonNull Map<String, ?> map1) {
                result.success(fortResponseMap);
            }

            @Override
            public void onFailure(@NonNull Map<String, ?> fortResponseMap, @NonNull Map<String, ?> map1) {
                result.error("onFailure", "onFailure", fortResponseMap);


            }
        });
    }

    private void handleOpenFullScreenPayfort(MethodCall call, Result result) {
        try {
            if (call.argument("environmentType").toString().equals("production"))
                mEnvironment = Constants.ENVIRONMENTS_VALUES.PRODUCTION;
            else
                mEnvironment = Constants.ENVIRONMENTS_VALUES.SANDBOX;

            boolean isShowResponsePage = call.argument("isShowResponsePage");
            HashMap<String, Object> requestParamMap = call.argument("requestParam");
            FortRequest fortRequest = new FortRequest();
            fortRequest.setShowResponsePage(isShowResponsePage);
            fortRequest.setRequestMap(requestParamMap);

            if (fortCallback == null)
                fortCallback = FortCallback.Factory.create();
            FortSdk.getInstance().registerCallback(activity, fortRequest, mEnvironment.getSdkEnvironemt(), PAYFORT_REQUEST_CODE, fortCallback, true, new FortInterfaces.OnTnxProcessed() {
                @Override
                public void onCancel(Map<String, Object> requestParamsMap, Map<String, Object> responseMap) {
                    result.error("onCancel", "onCancel", responseMap);
                }

                @Override
                public void onSuccess(Map<String, Object> requestParamsMap, Map<String, Object> fortResponseMap) {
                    result.success(fortResponseMap);
                }

                @Override
                public void onFailure(Map<String, Object> requestParamsMap, Map<String, Object> fortResponseMap) {
                    result.error("onFailure", "onFailure", fortResponseMap);
                }
            });
        } catch (Exception e) {
            HashMap<Object, Object> errorDetails = new HashMap<>();
            errorDetails.put("response_message", e.getMessage());
            result.error("onFailure", "onFailure", errorDetails);
        }
    }

}
