// 修正后的Stage模型规范写法
import UIAbility from '@kit.AbilityKit';
import type { Want, LaunchParam } from '@kit.AbilityKit';
import window from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  // 1. 显式声明生命周期参数类型
  onCreate(want: Want, launchParam: LaunchParam): void {
    console.info('[EntryAbility] onCreate');
  }

  // 2. 修复WindowStage类型声明
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err) {
        console.error("Failed to load content. Error:" + JSON.stringify(err));
        return;
      }
      console.log("Succeeded in loading content");
    });
  }

  // 3. 补全生命周期方法（可选但建议）
  onWindowStageDestroy(): void {
    console.info('[EntryAbility] onWindowStageDestroy');
  }

  onDestroy(): void {
    console.info('[EntryAbility] onDestroy');
  }
}