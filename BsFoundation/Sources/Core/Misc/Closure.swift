//
//  Closure.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

/// 入参为 Void，返回 Void
public typealias Block = () -> Void

/// 入参为 T，返回 Void
public typealias BlockT<T> = (T) -> Void

/// 入参为 T?，返回 Void
public typealias BlockTO<T> = (T?) -> Void

/// 入参为 T1，T2，返回 Void
public typealias BlockT2<T1, T2> = (T1, T2) -> Void

/// 入参为 Void，返回 T
public typealias BlockR<R> = () -> R

/// replace for target-action
public typealias Action<Object, Input> = (Object) -> BlockT<Input>

