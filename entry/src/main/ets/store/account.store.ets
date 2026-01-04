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

export interface StoredAccount {
  id: string;
  nickname: string;
  phone: string;
  email: string;
  passwordHash: string;
  createdAt: number;
}

export interface AccountProfile {
  id: string;
  nickname: string;
  phone?: string;
  email?: string;
  createdAt: number;
}

export interface AuthState {
  isLogin: boolean;
  profile?: AccountProfile;
}

export interface AuthResult {
  success: boolean;
  error?: string;
  profile?: AccountProfile;
}

const ACCOUNTS_KEY: string = 'account_profiles';
const CURRENT_ACCOUNT_KEY: string = 'account_current_id';

PersistentStorage.persistProp(ACCOUNTS_KEY, [] as StoredAccount[]);
PersistentStorage.persistProp(CURRENT_ACCOUNT_KEY, '');

function ensureInit(): void {
  if (AppStorage.get<StoredAccount[]>(ACCOUNTS_KEY) === undefined) {
    AppStorage.setOrCreate(ACCOUNTS_KEY, [] as StoredAccount[]);
  }
  if (AppStorage.get<string>(CURRENT_ACCOUNT_KEY) === undefined) {
    AppStorage.setOrCreate(CURRENT_ACCOUNT_KEY, '');
  }
}

function readAccounts(): StoredAccount[] {
  ensureInit();
  return (AppStorage.get<StoredAccount[]>(ACCOUNTS_KEY) ?? []) as StoredAccount[];
}

function writeAccounts(accounts: StoredAccount[]): void {
  AppStorage.set(ACCOUNTS_KEY, accounts);
}

function writeCurrentAccount(id: string): void {
  AppStorage.set(CURRENT_ACCOUNT_KEY, id);
}

function toProfile(account: StoredAccount): AccountProfile {
  return {
    id: account.id,
    nickname: account.nickname,
    phone: account.phone,
    email: account.email,
    createdAt: account.createdAt
  };
}

export class AccountStore {
  static getAuthState(): AuthState {
    ensureInit();
    const currentId: string = (AppStorage.get<string>(CURRENT_ACCOUNT_KEY) ?? '') as string;
    const accounts: StoredAccount[] = readAccounts();
    const target: StoredAccount | undefined = accounts.find((item: StoredAccount) => item.id === currentId);
    if (target) {
      return { isLogin: true, profile: toProfile(target) };
    }
    return { isLogin: false };
  }

  static register(nickname: string, phone: string, email: string, password: string): AuthResult {
    ensureInit();
    const nextNickname: string = nickname.trim();
    const nextPhone: string = phone.trim();
    const nextEmail: string = email.trim().toLowerCase();
    const nextPassword: string = password.trim();

    if (!nextNickname) {
      return { success: false, error: '请输入昵称' };
    }
    if (!nextPhone && !nextEmail) {
      return { success: false, error: '请输入手机号或邮箱' };
    }
    if (nextPassword.length < 6) {
      return { success: false, error: '密码长度至少 6 位' };
    }

    const accounts: StoredAccount[] = readAccounts();
    if (nextPhone && accounts.some((item: StoredAccount) => item.phone === nextPhone)) {
      return { success: false, error: '该手机号已注册' };
    }
    if (nextEmail && accounts.some((item: StoredAccount) => item.email === nextEmail)) {
      return { success: false, error: '该邮箱已注册' };
    }

    const account: StoredAccount = {
      id: `${Date.now()}`,
      nickname: nextNickname,
      phone: nextPhone,
      email: nextEmail,
      passwordHash: AccountStore.hashPassword(nextPassword),
      createdAt: Date.now()
    };

    writeAccounts([account, ...accounts]);
    writeCurrentAccount(account.id);
    return { success: true, profile: toProfile(account) };
  }

  static login(account: string, password: string): AuthResult {
    ensureInit();
    const accountInput: string = account.trim().toLowerCase();
    const passwordHash: string = AccountStore.hashPassword(password.trim());

    if (!accountInput) {
      return { success: false, error: '请输入手机号或邮箱' };
    }
    if (!password) {
      return { success: false, error: '请输入密码' };
    }

    const accounts: StoredAccount[] = readAccounts();
    const target: StoredAccount | undefined = accounts.find((item: StoredAccount) =>
      (item.phone && item.phone.toLowerCase() === accountInput) || (item.email && item.email.toLowerCase() === accountInput)
    );

    if (!target) {
      return { success: false, error: '账户不存在，请先注册' };
    }

    if (target.passwordHash !== passwordHash) {
      return { success: false, error: '密码不正确' };
    }

    writeCurrentAccount(target.id);
    return { success: true, profile: toProfile(target) };
  }

  static logout(): void {
    ensureInit();
    writeCurrentAccount('');
  }

  static hashPassword(value: string): string {
    let hash: number = 7;
    for (let i = 0; i < value.length; i++) {
      hash = (hash * 31 + value.charCodeAt(i) + i) % 1000000007;
    }
    return Math.abs(hash).toString();
  }
}
