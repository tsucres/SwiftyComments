
import UIKit
import SwiftScanner

// ==========================
// Adaptation of https://github.com/malcommac/SwiftRichString/blob/master/Sources/SwiftRichString/MarkupString.swift
// ==========================

class HNCommentContentParser {
    static let htmlEntities = ["quot":"\"","amp":"&","apos":"'","lt":"<","gt":">", "#x2F":"/", "#38":"&", "#62":">", "#x27":"'", "#60":"<"]
    
    /// Turns the html of a comment from Hackernews to an AttributedString
    /// valid html = https://news.ycombinator.com/formatdoc
    public static func buildAttributedText(From markup: String, textColor: UIColor = .white, fontSize: CGFloat = 14, linkColor: UIColor = .orange) -> NSAttributedString? {
        guard let (text, tags) = try? parse(markup) else {
            return nil
        }
        
        
        
        let attributedText = NSMutableAttributedString(string: text)
        let font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 0.4*font.lineHeight
        paragraphStyle.lineSpacing = 0.1*font.lineHeight
        attributedText.addAttributes([.font: font,
                                      .foregroundColor: textColor,
                                      NSAttributedString.Key.paragraphStyle: paragraphStyle
            ], range: NSRange.init(location: 0, length: text.count))
        for tag in tags {
            if tag.name == "a" {
                let initialLen = text.count
                var aContent = String(text.dropFirst(tag.range!.lowerBound))
                aContent = String(aContent.dropLast(initialLen - tag.range!.upperBound))
                let attributes: [NSAttributedString.Key: Any] = [.link: aContent, .underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: linkColor]
                attributedText.addAttributes(attributes, range: NSRange(tag.range!))
            } else if tag.name == "code" {
                let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Courier", size: 14)! ]
                attributedText.addAttributes(attributes, range: NSRange(tag.range!))
            } else if tag.name == "i" {
                let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.italicSystemFont(ofSize: 14)]
                attributedText.addAttributes(attributes, range: NSRange(tag.range!))
            } else if tag.name == "h1" { // for AskHN only
                let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18)]
                attributedText.addAttributes(attributes, range: NSRange(tag.range!))
            }
            
        }
        return NSAttributedString(attributedString: attributedText)
    }
    
    private static func parse(_ content: String) throws -> (text: String, tags: [Tag]) {
        let scanner = StringScanner(content)
        var tagStacks: [Tag] = [] // temporary stack
        var tagsList: [Tag] = [] // final stack with all found tags
        
        var plainText = String()
        while !scanner.isAtEnd {
            // scan text and accumulate it until we found a special entity (starting with &) or an open tag character (<)
            if let textString = try scanner.scan(upTo: CharacterSet(charactersIn: "<&")) {
                plainText += textString
            } else {
                // We have encountered a special entity or an open/close tag
                if scanner.match("&") == true {
                    // It's a special entity so get it until the end (; character) and replace it with encoded char
                    if let entityValue = try scanner.scan(upTo: ";") {
                        if let spec = htmlEntities[entityValue] {
                            plainText += spec
                        }
                        try scanner.skip()
                    }
                    continue
                } else if scanner.match("<") == true {
                    let rawTag = try scanner.scan(upTo: ">")

                    if var tag = Tag(raw: rawTag) {
                        if tag.name == "p" { // it's a return carriage, we want to translate it directly
                            plainText += "\n"
                            continue
                        }
                        let endIndex = plainText.count
                        if tag.isOpenTag == true {
                            // it's an open tag, store the start index
                            // (the upperbund is temporary the same of the lower bound, we will update it
                            // at the end, before adding it to the list of the tags)
                            tag.range = endIndex..<endIndex
                            tagStacks.append(tag)
                        } else {
                            let enumerator = tagStacks.enumerated().reversed()
                            for (index, var currentTag) in enumerator {
                                // Search back to the first opening closure for this tag, update the upper bound
                                // with the end position of the closing tag and put on the list
                                if currentTag.name == tag.name {
                                    currentTag.range = currentTag.range!.lowerBound..<endIndex
                                    tagsList.append(currentTag)
                                    tagStacks.remove(at: index)
                                    break
                                }
                            }
                        }
                    }
                    try scanner.skip()
                }
            }
        }
        return (plainText,tagsList)
    }
    
    internal struct Tag {
        /// The name of the tag
        public let name: String
        /// Range of tag
        public var range: Range<Int>?
        /// true if tag represent an open tag
        fileprivate(set) var isOpenTag: Bool
        /// the content of the href attribute (only if the tag name is 'a'
        public var href: String?
        
        public init?(raw content: String?) {
            guard let content = content else {
                return nil
            }
            // Read tag name
            let tagScanner = StringScanner(content)
            do {
                self.isOpenTag = (tagScanner.match("/") == false)
                guard let name = try tagScanner.scan(untilIn: CharacterSet.alphanumerics) else {
                    return nil
                }
                self.name = name
                if self.name == "a" {
                    let linkPattern = "href=\\\"(.*)\\\"" // #bestURLRegexEver
                    let linkRegex = try! NSRegularExpression(pattern: linkPattern, options: [])
                    let matches = linkRegex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
                    if matches.count > 0 {
                        let linkMatch = matches[0]
                        if linkMatch.numberOfRanges == 2 {
                            let startIndex = String.Index(encodedOffset: linkMatch.range(at: 1).lowerBound)
                            let endIndex = String.Index(encodedOffset: linkMatch.range(at: 1).upperBound)
                            self.href = String(content[startIndex..<endIndex])
                        }
                    }
                }
            } catch {
                return nil
            }
        }
    }
}
