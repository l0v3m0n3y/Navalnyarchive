# Navalnyarchive
api for navalny.com Это отдельный сайт, где мы сохранили все, что он делал: блог, соцсети, проекты, фотографии
# main
```swift
import Foundation
import Navalnyarchive
let client = NavalnyArchive()

do {
    let dailyPosts = try await client.getDailyPostsToday()
    print(dailyPosts)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
