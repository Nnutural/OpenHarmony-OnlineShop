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
import { CartStore } from '../store/cart.store';
import { getProductById, Product, ProductDetailBlock, ProductSku, ProductDetailTextBlock, ProductDetailImageBlock } from '../services/product.service';

@Component
struct ProductGallery {
  images: Resource[] = [];

  build() {
    if (this.images.length === 0) {
      Column() {
        Text('暂无图片')
          .fontColor(Color.Gray)
          .fontSize($r('app.float.small_font_size'))
      }
      .height(300)
      .width(Const.FULL_WIDTH)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
    } else {
      Swiper() {
        ForEach(this.images, (image: Resource, index: number) => {
          Image(image)
            .width(Const.FULL_WIDTH)
            .height(300)
            .objectFit(ImageFit.Contain)
        }, (image: Resource, index: number) => index.toString())
      }
      .width(Const.FULL_WIDTH)
      .height(300)
      .backgroundColor(Color.White)
      .indicator(true)
    }
  }
}

@Component
struct ProductHeader {
  product?: Product = undefined;

  build() {
    if (!this.product) {
      Blank()
    } else {
      Column() {
        Text(this.product.name)
          .fontSize(18)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 8 })

        Row() {
          Text(this.product.price)
            .fontSize(22)
            .fontColor($r('app.color.focus_color'))
            .fontWeight(FontWeight.Medium)

          if (this.product.discount) {
            Text(this.product.discount)
              .fontSize($r('app.float.smaller_font_size'))
              .fontColor(Color.Black)
              .opacity(Const.SIXTY_OPACITY)
              .margin({ left: 12 })
          }
        }
        .margin({ bottom: 8 })

        Row() {
          Text(`销量 ${this.product.sales}`)
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor(Color.Black)
            .opacity(Const.SIXTY_OPACITY)

          Text(`评分 ${this.product.rating}`)
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor(Color.Black)
            .opacity(Const.SIXTY_OPACITY)
            .margin({ left: 12 })
        }
        .margin({ bottom: 12 })

        if (this.product.tags.length > 0) {
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.product.tags, (tag: string, index: number) => {
              Text(tag)
                .fontSize($r('app.float.promotion_font_size'))
                .fontColor($r('app.color.focus_color'))
                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                .borderRadius(12)
                .backgroundColor('#FCE4EA')
                .margin({ right: 8, bottom: 8 })
            }, (tag: string, index: number) => `${tag}_${index}`)
          }
          .width(Const.FULL_WIDTH)
        }
      }
      .width(Const.FULL_WIDTH)
      .padding(12)
      .backgroundColor(Color.White)
      .borderRadius(12)
    }
  }
}

@Component
struct ProductSpecs {
  skus: ProductSku[] = [];
  selectedSkuId: string = '';
  onSkuChange?: (skuId: string) => void;

  build() {
    Column() {
      Text('规格')
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 12 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.skus, (sku: ProductSku, index: number) => {
          Text(sku.name)
            .fontSize($r('app.float.small_font_size'))
            .fontColor(this.selectedSkuId === sku.id ? Color.White : Color.Black)
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .backgroundColor(this.selectedSkuId === sku.id ? $r('app.color.focus_color') : '#F1F3F5')
            .borderRadius(16)
            .margin({ right: 8, bottom: 8 })
            .onClick(() => {
              this.onSkuChange?.(sku.id);
            })
        }, (sku: ProductSku, index: number) => `${sku.id}_${index}`)
      }
      .width(Const.FULL_WIDTH)
    }
    .width(Const.FULL_WIDTH)
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
  }
}

@Component
struct ProductDetail {
  blocks: ProductDetailBlock[] = [];

  build() {
    Column() {
      Text('图文详情')
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 12 })

      ForEach(this.blocks, (block: ProductDetailBlock, index: number) => {
        if (block.type === 'text') {
          Text((block as ProductDetailTextBlock).text)
            .fontSize($r('app.float.small_font_size'))
            .fontColor(Color.Black)
            .opacity(Const.EIGHTY_OPACITY)
            .margin({ bottom: 8 })
        } else {
          Image((block as ProductDetailImageBlock).image)
            .width(Const.FULL_WIDTH)
            .height(240)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 8 })
        }
      }, (block: ProductDetailBlock, index: number) => index.toString())
    }
    .width(Const.FULL_WIDTH)
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
  }
}

@Component
struct ActionBar {
  onAddToCart?: () => void;
  onBuyNow?: () => void;

  build() {
    Row() {
      Button('加入购物车')
        .layoutWeight(1)
        .height(44)
        .backgroundColor('#F1F3F5')
        .fontColor(Color.Black)
        .borderRadius(22)
        .onClick(() => {
          this.onAddToCart?.();
        })

      Button('立即购买')
        .layoutWeight(1)
        .height(44)
        .margin({ left: 12 })
        .backgroundColor($r('app.color.focus_color'))
        .fontColor(Color.White)
        .borderRadius(22)
        .onClick(() => {
          this.onBuyNow?.();
        })
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
    .shadow({ radius: 12, color: '#33000000', offsetX: 0, offsetY: -2 })
  }
}

@Entry
@Component
struct ProductDetailPage {
  @State private isLoading: boolean = true;
  @State private isError: boolean = false;
  @State private errorMessage: string = '';
  @State private product?: Product = undefined;
  @State private selectedSkuId: string = '';
  @StorageLink('topRectHeight') topRectHeight: number = 0;

  private productId: string = '';

  aboutToAppear(): void {
    const params: Record<string, string> = this.getUIContext().getRouter().getParams() as Record<string, string>;
    const idParam: string = params['productId'];
    this.productId = idParam ? idParam : '';
    this.loadProduct();
  }

  private async loadProduct(): Promise<void> {
    this.isLoading = true;
    this.isError = false;
    this.errorMessage = '';
    this.product = undefined;

    if (!this.productId) {
      this.isLoading = false;
      this.isError = true;
      this.errorMessage = '缺少 productId';
      return;
    }

    try {
      const data: Product = await getProductById(this.productId);
      this.product = data;
      this.selectedSkuId = data.skus.length > 0 ? data.skus[0].id : 'default';
    } catch (err) {
      this.isError = true;
      this.errorMessage = err instanceof Error ? err.message : '加载失败，请重试';
    } finally {
      this.isLoading = false;
    }
  }

  private addToCart(): void {
    if (!this.product) {
      return;
    }
    const sku: ProductSku = this.product.skus.find((item: ProductSku) => item.id === this.selectedSkuId) ?? this.product.skus[0];

    CartStore.add(this.product, sku, 1);
    try {
      this.getUIContext().getPromptAction().showToast({ message: '已加入购物车' });
    } catch {
    }
  }

  private buyNow(): void {
    try {
      this.getUIContext().getPromptAction().showToast({ message: '下单功能占位' });
    } catch {
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        this.buildTopBar()

        if (this.isLoading) {
          Column() {
            Text('加载中...')
              .fontSize($r('app.float.small_font_size'))
              .fontColor(Color.Gray)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .width(Const.FULL_WIDTH)
        } else if (this.isError) {
          Column() {
            Text(this.errorMessage)
              .fontSize($r('app.float.small_font_size'))
              .fontColor(Color.Gray)
              .margin({ bottom: 12 })
            Button('重试')
              .onClick(() => this.loadProduct())
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .width(Const.FULL_WIDTH)
        } else if (this.product) {
          Scroll() {
            Column() {
              ProductGallery({ images: this.product.images })
                .margin({ bottom: 12 })

              ProductHeader({ product: this.product })
                .margin({ bottom: 12 })

              ProductSpecs({
                skus: this.product.skus,
                selectedSkuId: this.selectedSkuId,
                onSkuChange: (skuId: string) => {
                  this.selectedSkuId = skuId;
                }
              })
                .margin({ bottom: 12 })

              ProductDetail({ blocks: this.product.detailBlocks })
                .margin({ bottom: 12 })
            }
            .padding({ left: 12, right: 12, top: 12, bottom: 84 })
          }
          .layoutWeight(1)
          .width(Const.FULL_WIDTH)
        }
      }
      .width(Const.FULL_WIDTH)

      if (!this.isLoading && !this.isError && this.product) {
        ActionBar({
          onAddToCart: () => this.addToCart(),
          onBuyNow: () => this.buyNow()
        })
      }
    }
    .width(Const.FULL_WIDTH)
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.home_background_color'))
  }

  @Builder
  private buildTopBar() {
    Row() {
      Text('返回')
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Black)
        .padding({ left: 8, right: 8, top: 8, bottom: 8 })
        .onClick(() => {
          this.getUIContext().getRouter().back();
        })

      Text('商品详情')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Medium)

      Blank()
        .width(48)
    }
    .width(Const.FULL_WIDTH)
    .padding({
      left: 12,
      right: 12,
      top: 6 + this.getUIContext().px2vp(this.topRectHeight),
      bottom: 6
    })
    .backgroundColor(Color.White)
  }
}
