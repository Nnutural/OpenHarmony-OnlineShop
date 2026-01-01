import ProductItem from "@bundle:com.huawei.waterflow/entry/ets/viewmodel/ProductItem";
import { productList } from "@bundle:com.huawei.waterflow/entry/ets/services/product.service";
/**
 * Home page classify title data.
 */
const classifyTitle: Resource[] = [
    { "id": 16777228, "type": 10003, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
    { "id": 16777230, "type": 10003, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
    { "id": 16777224, "type": 10003, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
    { "id": 16777225, "type": 10003, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
    { "id": 16777229, "type": 10003, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
    { "id": 16777226, "type": 10003, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
    { "id": 16777227, "type": 10003, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }
];
/**
 * Home page swiper image data.
 */
const swiperImage: Resource[] = [
    { "id": 16777233, "type": 20000, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
    { "id": 16777239, "type": 20000, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
    { "id": 16777236, "type": 20000, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }
];
/**
 * Home page water flow item init data.
 */
const bannerItem: ProductItem = new ProductItem('banner', { "id": 16777233, "type": 20000, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }, '', '', '', '', '');
const waterFlowData: ProductItem[] = [bannerItem, ...productList];
export { classifyTitle, swiperImage, waterFlowData };
