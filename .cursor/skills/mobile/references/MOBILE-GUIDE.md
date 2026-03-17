# 移动端开发最佳实践

## React Native (Expo)

### 路由配置
```typescript
// app/_layout.tsx
import { Stack } from 'expo-router';

export default function Layout() {
  return (
    <Stack screenOptions={{ headerShown: false }}>
      <Stack.Screen name="index" />
      <Stack.Screen name="profile" />
    </Stack>
  );
}
```

### 状态管理
```typescript
// zustand store
import { create } from 'zustand';

interface UserState {
  user: User | null;
  setUser: (user: User) => void;
}

export const useUserStore = create<UserState>((set) => ({
  user: null,
  setUser: (user) => set({ user }),
}));
```

### 原生模块
```typescript
// 使用原生能力
import * as Location from 'expo-location';
import * as ImagePicker from 'expo-image-picker';
import { CameraView } from 'expo-camera';
```

## Flutter

### 状态管理 (Riverpod)
```dart
// Provider
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);
  
  void setUser(User user) {
    state = user;
  }
}
```

### Widget
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, userNotifier, child) {
        return Text(userNotifier.user?.name ?? '');
      },
    );
  }
}
```

## 发布

### iOS
```bash
# Expo
eas build -p ios

# 本地
xcodebuild -workspace ios/MyApp.xcworkspace
```

### Android
```bash
# Expo
eas build -p android

# APK
cd android && ./gradlew assembleRelease
```

---
