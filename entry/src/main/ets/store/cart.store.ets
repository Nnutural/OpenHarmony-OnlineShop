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
import { ProductSku } from '../services/product.service';

export interface CartItem {
  productId: string;
  skuId: string;
  skuName: string;
  name: string;
  price: string;
  image_url: Resource;
  count: number;
}

const CART_ITEMS_KEY: string = 'cart_items';
const CART_TOTAL_COUNT_KEY: string = 'cart_total_count';

function ensureInit(): void {
  if (AppStorage.get<CartItem[]>(CART_ITEMS_KEY) === undefined) {
    AppStorage.setOrCreate(CART_ITEMS_KEY, [] as CartItem[]);
  }
  if (AppStorage.get<number>(CART_TOTAL_COUNT_KEY) === undefined) {
    AppStorage.setOrCreate(CART_TOTAL_COUNT_KEY, 0);
  }
}

function recalcTotalCount(items: CartItem[]): number {
  return items.reduce((sum: number, item: CartItem) => sum + item.count, 0);
}

export class CartStore {
  static add(product: ProductItem, sku: ProductSku, count: number): void {
    ensureInit();
    const safeCount: number = Math.max(1, Math.floor(count));
    const items: CartItem[] = (AppStorage.get<CartItem[]>(CART_ITEMS_KEY) ?? []) as CartItem[];
    const targetIndex: number = items.findIndex((item: CartItem) =>
      item.productId === product.id && item.skuId === sku.id);

    const nextItems: CartItem[] = items.slice();
    if (targetIndex >= 0) {
      const oldItem: CartItem = nextItems[targetIndex];
      nextItems[targetIndex] = {
        productId: oldItem.productId,
        skuId: oldItem.skuId,
        skuName: oldItem.skuName,
        name: oldItem.name,
        price: oldItem.price,
        image_url: oldItem.image_url,
        count: oldItem.count + safeCount
      };
    } else {
      nextItems.unshift({
        productId: product.id,
        skuId: sku.id,
        skuName: sku.name,
        name: product.name,
        price: product.price,
        image_url: product.image_url,
        count: safeCount
      });
    }

    AppStorage.set(CART_ITEMS_KEY, nextItems);
    AppStorage.set(CART_TOTAL_COUNT_KEY, recalcTotalCount(nextItems));
  }

  static remove(productId: string, skuId: string): void {
    ensureInit();
    const items: CartItem[] = (AppStorage.get<CartItem[]>(CART_ITEMS_KEY) ?? []) as CartItem[];
    const nextItems: CartItem[] = items.filter((item: CartItem) => !(item.productId === productId && item.skuId === skuId));
    AppStorage.set(CART_ITEMS_KEY, nextItems);
    AppStorage.set(CART_TOTAL_COUNT_KEY, recalcTotalCount(nextItems));
  }

  static updateCount(productId: string, skuId: string, count: number): void {
    ensureInit();
    const safeCount: number = Math.max(1, Math.floor(count));
    const items: CartItem[] = (AppStorage.get<CartItem[]>(CART_ITEMS_KEY) ?? []) as CartItem[];
    const nextItems: CartItem[] = items.map((item: CartItem) => {
      if (item.productId === productId && item.skuId === skuId) {
        return {
          productId: item.productId,
          skuId: item.skuId,
          skuName: item.skuName,
          name: item.name,
          price: item.price,
          image_url: item.image_url,
          count: safeCount
        };
      }
      return item;
    });
    AppStorage.set(CART_ITEMS_KEY, nextItems);
    AppStorage.set(CART_TOTAL_COUNT_KEY, recalcTotalCount(nextItems));
  }

  static totalCount(): number {
    ensureInit();
    return (AppStorage.get<number>(CART_TOTAL_COUNT_KEY) ?? 0) as number;
  }

  static getItems(): CartItem[] {
    ensureInit();
    return (AppStorage.get<CartItem[]>(CART_ITEMS_KEY) ?? []) as CartItem[];
  }
}
