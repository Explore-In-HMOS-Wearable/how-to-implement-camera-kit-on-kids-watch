import { camera, cameraPicker } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct Index {
  @Local photoUri: string = '';
  @Local hint: string = 'Tap the button to take a photo';
  private readonly TAG: string = 'CameraKitGuide';

  build() {
    Column({ space: 16 }) {
      if (this.photoUri.length > 0) {
        // The captured photo. `resultUri` is a file URI that Image() reads directly.
        Image(this.photoUri)
          .width('70%')
          .objectFit(ImageFit.Contain)
          .borderRadius(12)
          .backgroundColor(Color.Gray)
      } else {
        Text(this.hint)
          .fontSize(14)
          .fontColor(Color.Gray)
          .width('70%')
          .textAlign(TextAlign.Center)
      }

      Button('Take photo')
        .onClick(() => {
          this.takePhoto();
        })
    }
    .backgroundColor(Color.Black)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(16)
  }

  /** Opens the Camera Kit picker and stores the captured photo's URI. */
  private async takePhoto(): Promise<void> {
    const context = this.getUIContext().getHostContext() as common.Context;
    try {
      const profile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_FRONT
      };
      const result: cameraPicker.PickerResult =
        await cameraPicker.pick(context, [cameraPicker.PickerMediaType.PHOTO], profile);
      // resultCode 0 = a photo was captured; any other value = the user cancelled.
      if (result.resultCode === 0) {
        this.photoUri = result.resultUri;
      } else {
        this.hint = 'Capture cancelled';
      }
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${this.TAG} camera pick failed: ${e.code} - ${e.message}`);
      this.hint = 'Could not open the camera';
    }
  }
}