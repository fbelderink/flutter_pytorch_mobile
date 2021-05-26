package io.fynn.pytorch_mobile;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import org.pytorch.DType;
import org.pytorch.IValue;
import org.pytorch.Module;
import org.pytorch.Tensor;
import org.pytorch.torchvision.TensorImageUtils;

// Native Loader for torchscript support
import com.facebook.soloader.nativeloader.NativeLoader;
import com.facebook.soloader.nativeloader.SystemDelegate;

import java.util.ArrayList;

/** TorchMobilePlugin */
public class PyTorchMobilePlugin implements FlutterPlugin, MethodCallHandler {
  
  static {
    if (!NativeLoader.isInitialized()) {
      NativeLoader.init(new SystemDelegate());
    }
    NativeLoader.loadLibrary("pytorch_jni");
    NativeLoader.loadLibrary("torchvision_ops");
  }

  ArrayList<Module> modules = new ArrayList<>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),
        "pytorch_mobile");
    channel.setMethodCallHandler(new PyTorchMobilePlugin());
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "pytorch_mobile");
    channel.setMethodCallHandler(new PyTorchMobilePlugin());
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
          Log.e("PyTorchMobile", assetPath + " is not a proper model", e);
        }
        break;
      case "predict":
        Module module = null;
        Integer[] shape = null;
        Double[] data = null;
        DType dtype = null;

        try{
          int index = call.argument("index");
          module = modules.get(index);

          dtype = DType.valueOf(call.argument("dtype").toString().toUpperCase());

          ArrayList<Integer> shapeList = call.argument("shape");
          shape = shapeList.toArray(new Integer[shapeList.size()]);

          ArrayList<Double> dataList = call.argument("data");
          data = dataList.toArray(new Double[dataList.size()]);

        }catch(Exception e){
          Log.e("PyTorchMobile", "error parsing arguments", e);
        }

        //prepare input tensor
        final Tensor inputTensor = getInputTensor(dtype, data, shape);

        //run model
        Tensor outputTensor = null;
        try {
          outputTensor = module.forward(IValue.from(inputTensor)).toTensor();
        }catch(RuntimeException e){
          Log.e("PyTorchMobile", "Your input type " + dtype.toString().toLowerCase()  + " (" + Convert.dtypeAsPrimitive(dtype.toString()) +") " + "does not match with model input type",e);
          result.success(null);
        }

        successResult(result, dtype, outputTensor);

        break;
      case "predictImage":
        Module imageModule = null;
        Bitmap bitmap = null;
        try {
          int index = call.argument("index");
          byte[] imageData = call.argument("image");
          int width = call.argument("width");
          int height = call.argument("height");

          imageModule = modules.get(index);

          bitmap = BitmapFactory.decodeByteArray(imageData,0,imageData.length);

          bitmap = Bitmap.createScaledBitmap(bitmap, width, height, false);

        }catch (Exception e){
          Log.e("PyTorchMobile", "error reading image", e);
        }

        final Tensor imageInputTensor = TensorImageUtils.bitmapToFloat32Tensor(bitmap,
                TensorImageUtils.TORCHVISION_NORM_MEAN_RGB, TensorImageUtils.TORCHVISION_NORM_STD_RGB);

        final Tensor imageOutputTensor = imageModule.forward(IValue.from(imageInputTensor)).toTensor();

        float[] scores = imageOutputTensor.getDataAsFloatArray();

        ArrayList<Float> out = new ArrayList<>();
        for(float f : scores){
          out.add(f);
        }

        result.success(out);

        break;
      default:
        result.notImplemented();
        break;
    }
  }

  //returns input tensor depending on dtype
  private Tensor getInputTensor(DType dtype, Double[] data, Integer[] shape){
    switch (dtype){
      case FLOAT32:
        return Tensor.fromBlob(Convert.toFloatPrimitives(data), Convert.toPrimitives(shape));
      case FLOAT64:
        return  Tensor.fromBlob(Convert.toDoublePrimitives(data), Convert.toPrimitives(shape));
      case INT32:
        return Tensor.fromBlob(Convert.toIntegerPrimitives(data), Convert.toPrimitives(shape));
      case INT64:
        return Tensor.fromBlob(Convert.toLongPrimitives(data), Convert.toPrimitives(shape));
      case INT8:
        return Tensor.fromBlob(Convert.toBytePrimitives(data), Convert.toPrimitives(shape));
      case UINT8:
        return Tensor.fromBlobUnsigned(Convert.toBytePrimitives(data), Convert.toPrimitives(shape));
      default:
        return null;
    }
  }

  //gets tensor depending on dtype and creates list of it, which is being returned
  private void successResult(Result result, DType dtype, Tensor outputTensor){
    switch (dtype){
      case FLOAT32:
        ArrayList<Float> outputListFloat = new ArrayList<>();
        for(float f : outputTensor.getDataAsFloatArray()){
          outputListFloat.add(f);
        }
        result.success(outputListFloat);
        break;
      case FLOAT64:
        ArrayList<Double> outputListDouble = new ArrayList<>();
        for(double d : outputTensor.getDataAsDoubleArray()){
          outputListDouble.add(d);
        }
        result.success(outputListDouble);
        break;
      case INT32:
        ArrayList<Integer> outputListInteger = new ArrayList<>();
        for(int i : outputTensor.getDataAsIntArray()){
          outputListInteger.add(i);
        }
        result.success(outputListInteger);
        break;
      case INT64:
        ArrayList<Long> outputListLong = new ArrayList<>();
        for(long l : outputTensor.getDataAsLongArray()){
          outputListLong.add(l);
        }
        result.success(outputListLong);
        break;
      case INT8:
        ArrayList<Byte> outputListByte = new ArrayList<>();
        for(byte b : outputTensor.getDataAsByteArray()){
          outputListByte.add(b);
        }
        result.success(outputListByte);
        break;
      case UINT8:
        ArrayList<Byte> outputListUByte = new ArrayList<>();
        for(byte ub : outputTensor.getDataAsUnsignedByteArray()){
          outputListUByte.add(ub);
        }
        result.success(outputListUByte);
        break;
      default:
        result.success(null);
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
