import UIKit

extension UITextView {
    func setPadding(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}

extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap({ $0 as? PlaceholderLabel }).first {
            label.isHidden = !text.isEmpty
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            label.isHidden = !text.isEmpty
            return label
        }
    }

    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap({ $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.textColor = .lightGray
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2 - textContainerInset.left * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding + textContainerInset.left, y: textContainerInset.top)

            textStorage.delegate = self
        }
    }

    func moveCursorToEnd() {
        DispatchQueue.main.async {
            self.selectedTextRange = self.textRange(from: self.endOfDocument, to: self.endOfDocument)
        }
    }
}

extension UITextView: NSTextStorageDelegate {
    public func textStorage(
        _ textStorage: NSTextStorage,
        didProcessEditing editedMask: NSTextStorage.EditActions,
        range editedRange: NSRange,
        changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

}

private var maxLengths = [UITextView: Int]()

extension UITextView: UITextViewDelegate {

    @IBInspectable var maxLength: Int {

        get {

            guard let length = maxLengths[self]
                else {
                    return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            self.delegate = self
        }
    }

    @objc func limitLength(textView: UITextView) {
        guard let prospectiveText = textView.text,
            prospectiveText.count > maxLength
            else {
                return
        }

        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText[..<maxCharIndex])
        selectedTextRange = selection

    }

    public func textViewDidChange(_ textView: UITextView) {
        limitLength(textView: textView)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let currentText = textView.text, let range = Range(range, in: currentText) {
            let newText = currentText.replacingCharacters(in: range, with: text)
            if newText.utf16.count > textView.maxLength {
                let subStringText = newText.substringWithEncodedOffset(startIndex: 0, endIndex: textView.maxLength)
                textView.text = subStringText
                textView.moveCursorToEnd()
                return false
            }
        }
        return true
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        scrollToBottom()
        return true
    }

    func scrollToBottom() {
        let location = text.count - 1
        let bottom = NSRange(location: location, length: 1)
        self.scrollRangeToVisible(bottom)
    }
}

extension String {
    func substringWithEncodedOffset(startIndex: Int, endIndex: Int) -> String {
        let start = String.Index(utf16Offset: startIndex, in: self)
        let end = String.Index(utf16Offset: endIndex, in: self)
        return String(self[start..<end])
    }
}
