package io.fynn.torch_mobile;

import android.util.Log;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import org.pytorch.IValue;
import org.pytorch.Module;
import org.pytorch.Tensor;
import org.pytorch.torchvision.TensorImageUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/** TorchMobilePlugin */
public class TorchMobilePlugin implements FlutterPlugin, MethodCallHandler {

  ArrayList<Module> modules = new ArrayList<>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),
        "torch_mobile");
    channel.setMethodCallHandler(new TorchMobilePlugin());
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "torch_mobile");
    channel.setMethodCallHandler(new TorchMobilePlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method){
      case "loadModel":
        try {
          String absPath = call.argument("absPath");
          modules.add(Module.load(absPath));
          result.success(modules.size() - 1);
        } catch (Exception e) {
          String assetPath = call.argument("assetPath");
          Log.e("TorchMobile", assetPath + " is not a proper model", e);
        }
        break;
      case "predict":
        Module module;
        try{
          int index = call.argument("index");
          module = modules.get(index);

          ArrayList<Long> shapeList = call.argument("shape");
          Long[] shape = shapeList.toArray(new Long[shapeList.size()]);
          Tensor.fromBlob(new int[]{1,2,3,4}, toPrimitives(shape));

        }catch(Exception e){
          Log.e("TorchMobile", "", e);
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  public static long[] toPrimitives(Long[] objects){
    long[] primitives = new long[objects.length];
    for(int i = 0; i < objects.length; i++){
      primitives[i] = objects[i];
    }
    return primitives;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
