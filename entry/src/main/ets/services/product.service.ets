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

import ProductItem from '../viewmodel/ProductItem';

export class ProductSku {
  id: string;
  name: string;

  constructor(id: string, name: string) {
    this.id = id;
    this.name = name;
  }
}

export abstract class ProductDetailBlock {
  type: string;

  protected constructor(type: string) {
    this.type = type;
  }
}

export class ProductDetailTextBlock extends ProductDetailBlock {
  text: string;

  constructor(text: string) {
    super('text');
    this.text = text;
  }
}

export class ProductDetailImageBlock extends ProductDetailBlock {
  image: Resource;

  constructor(image: Resource) {
    super('image');
    this.image = image;
  }
}

export class Product extends ProductItem {
  images: Resource[];
  tags: string[];
  sales: number;
  rating: number;
  skus: ProductSku[];
  detailBlocks: ProductDetailBlock[];

  constructor(id: string, imageUrl: Resource, name: string, discount: string, price: string, promotion: string, bonusPoints: string,
    images: Resource[], tags: string[], sales: number, rating: number, skus: ProductSku[], detailBlocks: ProductDetailBlock[]) {
    super(id, imageUrl, name, discount, price, promotion, bonusPoints);
    this.images = images;
    this.tags = tags;
    this.sales = sales;
    this.rating = rating;
    this.skus = skus;
    this.detailBlocks = detailBlocks;
  }
}

const hotSearchKeywords: string[] = ['手机', '平板', '电脑', '新品', '优惠'];

const products: Product[] = [
  new Product('p_50e', $r('app.media.ic_holder_50e'), 'XXX50E', '', '¥4088', '', '',
    [$r('app.media.ic_holder_50e'), $r('app.media.ic_holder_mate50'), $r('app.media.ic_holder_60pro')],
    ['新品', '官方保障'],
    1200, 4.8,
    [new ProductSku('default', '默认规格')],
    [new ProductDetailTextBlock('旗舰性能，畅快体验。'), new ProductDetailTextBlock('支持多场景使用，长续航更安心。'),
      new ProductDetailImageBlock($r('app.media.ic_holder_50e'))]),

  new Product('p_xs2', $r('app.media.ic_holder_xs2'), 'XXXPadMate Xs 2 \n8GB+256GB （雅黑）', '', '¥9999', '限时', '',
    [$r('app.media.ic_holder_xs2'), $r('app.media.ic_holder_pad'), $r('app.media.ic_holder_computer')],
    ['平板', '大屏'],
    560, 4.6,
    [new ProductSku('8g_256g_black', '8GB+256GB（雅黑）'), new ProductSku('8g_256g_gray', '8GB+256GB（灰）')],
    [new ProductDetailTextBlock('轻薄机身，办公娱乐两相宜。'), new ProductDetailTextBlock('高刷屏幕，观感细腻。'),
      new ProductDetailImageBlock($r('app.media.ic_holder_xs2'))]),

  new Product('p_computer_01', $r('app.media.ic_holder_computer'), 'XX设备  新品优惠！新品优惠！机不可失！失不再来！快来购买！快来购买！',
    '限时省200', '¥10099', '商品', '',
    [$r('app.media.ic_holder_computer'), $r('app.media.ic_holder_mouse'), $r('app.media.ic_holder_pad')],
    ['电脑', '新品'],
    320, 4.5,
    [new ProductSku('i5_16g_512g', 'i5/16G/512G'), new ProductSku('i7_16g_1t', 'i7/16G/1T')],
    [new ProductDetailTextBlock('高效生产力，满足日常办公与创作。'), new ProductDetailTextBlock('丰富接口，连接更便捷。'),
      new ProductDetailImageBlock($r('app.media.ic_holder_computer'))]),

  new Product('p_mouse_01', $r('app.media.ic_holder_mouse'), '送给亲人  快速购买！', '限时省200', '¥199', '', '',
    [$r('app.media.ic_holder_mouse'), $r('app.media.ic_holder_computer'), $r('app.media.ic_holder_pad')],
    ['配件', '办公'],
    888, 4.7,
    [new ProductSku('default', '默认规格')],
    [new ProductDetailTextBlock('人体工学设计，握持舒适。'), new ProductDetailTextBlock('多档 DPI 可调，精准操控。'),
      new ProductDetailImageBlock($r('app.media.ic_holder_mouse'))]),

  new Product('p_pad_pro', $r('app.media.ic_holder_pad'), 'XXXPad Pro', '', '¥3499', '', '',
    [$r('app.media.ic_holder_pad'), $r('app.media.ic_holder_xs2'), $r('app.media.ic_holder_60pro')],
    ['平板', '影音'],
    430, 4.4,
    [new ProductSku('8g_128g', '8GB+128GB'), new ProductSku('12g_256g', '12GB+256GB')],
    [new ProductDetailTextBlock('沉浸大屏，追剧更爽。'), new ProductDetailTextBlock('多窗口协同，效率提升。'),
      new ProductDetailImageBlock($r('app.media.ic_holder_pad'))]),

  new Product('p_mate50', $r('app.media.ic_holder_mate50'), 'XXXMate 50 8GB+256GB', '', '¥5499', '', '',
    [$r('app.media.ic_holder_mate50'), $r('app.media.ic_holder_50e'), $r('app.media.ic_holder_60pro')],
    ['手机', '影像'],
    980, 4.9,
    [new ProductSku('8g_256g', '8GB+256GB'), new ProductSku('12g_512g', '12GB+512GB')],
    [new ProductDetailTextBlock('高能影像系统，记录每一刻。'), new ProductDetailTextBlock('流畅系统体验，久用如新。'),
      new ProductDetailImageBlock($r('app.media.ic_holder_mate50'))]),

  new Product('p_60pro', $r('app.media.ic_holder_60pro'), 'XXX60 Pro 新品上市！\n你值得拥有！\n限时折扣！\n速速购买！',
    '限时省200', '¥1299', '限时', '',
    [$r('app.media.ic_holder_60pro'), $r('app.media.ic_holder_50e'), $r('app.media.ic_holder_mate50')],
    ['新品', '优惠'],
    2100, 4.3,
    [new ProductSku('6g_128g', '6GB+128GB'), new ProductSku('8g_256g', '8GB+256GB')],
    [new ProductDetailTextBlock('新品上市，超值体验。'), new ProductDetailTextBlock('轻松上手，适合全家。'),
      new ProductDetailImageBlock($r('app.media.ic_holder_60pro'))])
];

function delay(durationMs: number): Promise<void> {
  return new Promise((resolve: () => void) => {
    setTimeout(resolve, durationMs);
  });
}

export const productList: ProductItem[] = products;

export function getHotSearchKeywords(): string[] {
  return hotSearchKeywords;
}

export async function getProductById(productId: string): Promise<Product> {
  await delay(200);
  const product: Product | undefined = products.find((item: Product) => item.id === productId);
  if (product === undefined) {
    throw new Error('商品不存在');
  }
  return product;
}

export async function searchProducts(query: string): Promise<ProductItem[]> {
  await delay(120);
  const normalizedQuery: string = query.trim().toLowerCase();
  if (!normalizedQuery) {
    return products;
  }

  return products.filter((item: Product) => {
    const name: string = item.name.toLowerCase();
    const tags: string = item.tags.join(' ').toLowerCase();
    return name.includes(normalizedQuery) || tags.includes(normalizedQuery);
  });
}
