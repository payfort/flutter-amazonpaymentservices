package com.amazon.flutter_amazonpaymentservices;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Build;
import android.os.Bundle;
import android.view.DisplayCutout;
import android.view.View;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowInsetsController;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * PayFort draws its payment header at the top of the window. Apps targeting
 * Android 15+ run edge to edge, so this applies the system-bar and cutout
 * insets to those screens once the window is attached.
 */
final class PayfortSystemBarFix {
    private static final String PAYFORT_PACKAGE = "com.payfort.fortpaymentsdk.";
    private static final AtomicBoolean INSTALLED = new AtomicBoolean(false);

    private static final Application.ActivityLifecycleCallbacks CALLBACKS =
            new Application.ActivityLifecycleCallbacks() {
                @Override
                public void onActivityPreCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
                }

                @Override
                public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
                }

                @Override
                public void onActivityStarted(@NonNull Activity activity) {
                    installInsets(activity);
                }

                @Override
                public void onActivityResumed(@NonNull Activity activity) {
                }

                @Override
                public void onActivityPaused(@NonNull Activity activity) {
                }

                @Override
                public void onActivityStopped(@NonNull Activity activity) {
                }

                @Override
                public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
                }

                @Override
                public void onActivityDestroyed(@NonNull Activity activity) {
                }
            };

    private PayfortSystemBarFix() {
    }

    static void install(Context context) {
        Context appContext = context.getApplicationContext();
        if (!(appContext instanceof Application)) {
            return;
        }
        if (INSTALLED.compareAndSet(false, true)) {
            ((Application) appContext).registerActivityLifecycleCallbacks(CALLBACKS);
        }
    }

    private static void installInsets(final Activity activity) {
        if (!shouldFix(activity)) {
            return;
        }
        final View content = activity.findViewById(android.R.id.content);
        if (content == null) {
            return;
        }
        content.setOnApplyWindowInsetsListener(new View.OnApplyWindowInsetsListener() {
            @Override
            public WindowInsets onApplyWindowInsets(View view, WindowInsets insets) {
                int left;
                int top;
                int right;
                int bottom;
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    android.graphics.Insets bars = insets.getInsets(
                            WindowInsets.Type.systemBars() | WindowInsets.Type.displayCutout());
                    left = bars.left;
                    top = bars.top;
                    right = bars.right;
                    bottom = bars.bottom;
                } else {
                    left = insets.getSystemWindowInsetLeft();
                    top = insets.getSystemWindowInsetTop();
                    right = insets.getSystemWindowInsetRight();
                    bottom = insets.getSystemWindowInsetBottom();
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        DisplayCutout cutout = insets.getDisplayCutout();
                        if (cutout != null) {
                            left = Math.max(left, cutout.getSafeInsetLeft());
                            top = Math.max(top, cutout.getSafeInsetTop());
                            right = Math.max(right, cutout.getSafeInsetRight());
                            bottom = Math.max(bottom, cutout.getSafeInsetBottom());
                        }
                    }
                }
                view.setPadding(left, top, right, bottom);
                if (top > 0) {
                    setDarkStatusBarIcons(activity);
                }
                return insets;
            }
        });
        content.post(new Runnable() {
            @Override
            public void run() {
                content.requestApplyInsets();
            }
        });
    }

    private static boolean shouldFix(Activity activity) {
        if (activity.getWindow() == null
                || !activity.getClass().getName().startsWith(PAYFORT_PACKAGE)) {
            return false;
        }
        TypedArray attributes = activity.getTheme().obtainStyledAttributes(new int[]{
                android.R.attr.windowIsTranslucent,
                android.R.attr.windowIsFloating
        });
        try {
            return !attributes.getBoolean(0, false) && !attributes.getBoolean(1, false);
        } finally {
            attributes.recycle();
        }
    }

    @SuppressWarnings("deprecation")
    private static void setDarkStatusBarIcons(Activity activity) {
        Window window = activity.getWindow();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            WindowInsetsController controller = window.getInsetsController();
            if (controller != null) {
                controller.setSystemBarsAppearance(
                        WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS,
                        WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS);
            }
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            View decor = window.getDecorView();
            decor.setSystemUiVisibility(decor.getSystemUiVisibility() | View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
        }
    }
}
