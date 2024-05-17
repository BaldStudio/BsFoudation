//
//  Closure.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

/// 闭包，入参为 Void，出参 Void
public typealias Block = () -> Void

/// 闭包，入参为 T，出参 Void
public typealias BlockT<T> = (T) -> Void

public typealias BlockT1N<T> = (T?) -> Void

/// 闭包，入参为 T1，T2，出参 Void
public typealias BlockT2<T1, T2> = (T1, T2) -> Void

/// 闭包，入参为 Void，出参 T
public typealias BlockR<T> = () -> T

/// replace for target-action
public typealias Action<Type, Input> = (Type) -> BlockT<Input>

