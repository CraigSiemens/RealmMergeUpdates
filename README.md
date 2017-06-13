The model is just

```swift
class Model: Object {
    dynamic var number: Int
}
```

The table has two sections. Each one has it's own `Results` providing data and handling change notifications.

Clicking the refresh icon will cause a `Model` object to be edited so it moves from section 0 to section 1 (or vice versa).

The animated switch changes whether it tries to animate the changes sent to the table.

- on
  - calls `beginUpdates`, `insertRows` ...etc
  - causes a crash
- off
  - calls `reloadData`
  - works but nothing is animated
