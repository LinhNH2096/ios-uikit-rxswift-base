protocol PersistentDataSaveable {
    func getItem(fromKey key: String) -> Any?
    func set(item: Any, toKey key: String)
}
