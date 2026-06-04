# Navalnyarchive
api for navalny.com Это отдельный сайт, где мы сохранили все, что он делал: блог, соцсети, проекты, фотографии
# main
```swift
import Foundation
import Navalnyarchive
let client = NavalnyArchive()

do {
    let daily_posts = try await client.get_daily_posts_today()
    print(daily_posts)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
