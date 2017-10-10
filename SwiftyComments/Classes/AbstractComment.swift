//
//  AbstractComment.swift
//  Commenting
//
//  Created by Stéphane Sercu on 9/10/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import Foundation

/// Defines the minimal properties a comment model must have (requiered by the CommentsViewController)
public protocol AbstractComment: class {
    var replies: [AbstractComment]! { get set }
    var level: Int! { get set }
    weak var replyTo: AbstractComment? { get set }
}
