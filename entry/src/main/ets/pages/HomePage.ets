/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants as Const } from '../common/constants/CommonConstants';
import ClassifyComponent from '../view/ClassifyComponent';
import SearchComponent from '../view/SearchComponent';
import WaterFlowComponent from '../view/WaterFlowComponent';

/**
 * The home page consists of four components: search component,
 * classify component, swiper component, and waterfall flow component.
 * How to use: These four components are invoked where the control is used.
 */
@Entry
@Component
struct HomePage {
  @StorageLink('topRectHeight') topRectHeight: number = 0;
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0;

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.ic_app_background'))
          .width(Const.FULL_WIDTH)
          .height($r('app.float.image_background_height'))
          .objectFit(ImageFit.Cover)
        Column() {
          SearchComponent()
          ClassifyComponent()
        }
        .width(Const.FULL_WIDTH)
        .padding({
          left: $r('app.float.home_margin_left'),
          right: $r('app.float.home_margin_right'),
          top: this.getUIContext().px2vp(this.topRectHeight)
        })
      }

      Column() {
        WaterFlowComponent()
          .layoutWeight(Const.WATER_FLOW_LAYOUT_WEIGHT)
        this.buildNavBar()
      }
      .width(Const.FULL_WIDTH)
      .layoutWeight(1)
      .padding({
        left: $r('app.float.home_margin_left'),
        right: $r('app.float.home_margin_right')
      })
    }
    .width(Const.FULL_WIDTH)
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.home_background_color'))
  }

  @Builder
  private buildNavBar() {
    Row() {
      this.navItem('产品', true, () => {})
      this.navItem('推荐', false, () => {})
      this.navItem('购物车', false, () => {
        try {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/CartPage' });
        } catch {
        }
      })
      this.navItem('账户', false, () => {})
    }
    .width(Const.FULL_WIDTH)
    .height($r('app.float.home_nav_height'))
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.SpaceAround)
    .padding({ bottom: this.getUIContext().px2vp(this.bottomRectHeight) / 2 })
  }

  @Builder
  private navItem(label: string, active: boolean, onClick?: () => void) {
    Column() {
      Text(label)
        .fontSize($r('app.float.small_font_size'))
        .fontColor(active ? $r('app.color.focus_color') : Color.Gray)
        .fontWeight(active ? FontWeight.Bold : FontWeight.Medium)
    }
    .width('20%')
    .height($r('app.float.home_nav_height'))
    .justifyContent(FlexAlign.Center)
    .onClick(() => onClick?.())
  }
}
