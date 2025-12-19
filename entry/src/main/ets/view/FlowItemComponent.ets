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
import ProductItem from '../viewmodel/ProductItem';
import { waterFlowData } from '../viewmodel/HomeViewModel';
import SwiperComponent from './SwiperComponent';

/**
 * Flow item component.
 * Usage: This component is used in FlowItem.
 */
@Component
export default struct FlowItemComponent {
  item: ProductItem = waterFlowData[0];
  onItemClick?: (item: ProductItem) => void;

  build() {
    if (this.item.id === 'banner') {
      Column() {
        SwiperComponent()
          .width(Const.FULL_WIDTH)
          .height($r('app.float.swiper_image_height'))
      }
      .width(Const.FULL_WIDTH)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        // banner 不跳转
      })
    } else {
      Column() {
        Column() {
          Image(this.item?.image_url)
            .width(Const.FULL_WIDTH)
            .height($r('app.float.product_card_image_height'))
            .objectFit(ImageFit.Contain)
            .margin({
              top: $r('app.float.water_flow_image_top'),
              bottom: $r('app.float.water_flow_image_bottom')
            })
        }
        .width(Const.FULL_WIDTH)
        .height($r('app.float.product_card_image_height'))
        .backgroundColor('#FAFBFD')
        .borderRadius({ topLeft: $r('app.float.product_layout_radius'), topRight: $r('app.float.product_layout_radius'), bottomLeft: 0, bottomRight: 0 })

        Column() {
          Text(this.item?.name)
            .fontSize($r('app.float.small_font_size'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
            .alignSelf(ItemAlign.Start)
          Text(this.item?.discount)
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Medium)
            .opacity(Const.SIXTY_OPACITY)
            .alignSelf(ItemAlign.Start)
            .margin({
              bottom: $r('app.float.discount_text_bottom')
            })
          Text(this.item?.price)
            .fontSize($r('app.float.middle_font_size'))
            .fontColor($r('app.color.focus_color'))
            .fontWeight(FontWeight.Bold)
            .alignSelf(ItemAlign.Start)
            .lineHeight($r('app.float.piece_line_height'))
          Row() {
            if (this.item?.promotion) {
              Text(`${this.item?.promotion}`)
                .height($r('app.float.promotion_text_height'))
                .fontSize($r('app.float.promotion_font_size'))
                .fontColor(Color.White)
                .borderRadius($r('app.float.promotion_radius'))
                .backgroundColor($r('app.color.focus_color'))
                .padding({
                  left: $r('app.float.promotion_padding_left'),
                  right: $r('app.float.promotion_padding_right')
                })
                .margin({
                  top: $r('app.float.promotion_margin_top'),
                  right: $r('app.float.promotion_margin_right')
                })
            }
            if (this.item?.bonus_points) {
              Text(`${this.item?.bonus_points}`)
                .height($r('app.float.promotion_text_height'))
                .fontSize($r('app.float.promotion_font_size'))
                .fontColor($r('app.color.focus_color'))
                .borderRadius($r('app.float.promotion_radius'))
                .borderWidth($r('app.float.bonus_points_radius_width'))
                .borderColor($r('app.color.focus_color'))
                .padding({
                  left: $r('app.float.bonus_points_padding_left'),
                  right: $r('app.float.bonus_points_padding_right')
                })
                .margin({ top: $r('app.float.bonus_points_margin_top') })
            }
          }
          .width(Const.FULL_WIDTH)
          .justifyContent(FlexAlign.Start)
        }
        .width(Const.FULL_WIDTH)
        .layoutWeight(1)
        .backgroundColor(Color.White)
        .padding({
          left: $r('app.float.product_layout_margin_left'),
          right: $r('app.float.product_layout_margin_right'),
          bottom: $r('app.float.product_layout_margin_bottom'),
          top: $r('app.float.product_layout_margin_bottom')
        })
      }
      .borderRadius($r('app.float.product_layout_radius'))
      .backgroundColor(Color.White)
      .width(Const.FULL_WIDTH)
      .height($r('app.float.product_card_height'))
      .onClick(() => {
        this.onItemClick?.(this.item);
      })
    }
  }
}
