//
//  Closure.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

public typealias Block = () -> Void

public typealias BlockT<T> = (T) -> Void

public typealias BlockTN<T> = (T?) -> Void

/// replace for target-action
public typealias Action<Type, Input> = (Type) -> (Input) -> Void
