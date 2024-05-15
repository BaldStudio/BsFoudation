//
//  MachO.swift
//  BsFoundation
//
//  Created by crzorz on 2022/10/17.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import Foundation
import MachO

public protocol MachODataConvertible {
    associatedtype RawType
    static func convert(_ t: RawType) -> Self
}

/// 这里如果是 struct 会崩，莫名其妙的
public final class MachOSegment {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }

    // refer to __DATA
    public static let data = MachOSegment(name: SEG_DATA)
    
    // refer to __TEXT
    public static let text = MachOSegment(name: SEG_TEXT)

}

public final class MachOSection {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }

    // refer to __data
    public static let data = MachOSection(name: SECT_DATA)
    
    // refer to __text
    public static let text = MachOSection(name: SECT_TEXT)
}

public func loadMachOData<T: MachODataConvertible>(segment: MachOSegment,
                                                   section: MachOSection) -> [T] {
    
    var frameworkNames: [String] = []
    
    /*
        按照下面的目录找二进制文件，其他目录看情况加吧
     
        ├── Demo   # App的主二进制，包含需要找的静态库信息
        ├── Frameworks # App的动态库目录
        ├── Plugins # 其他Bundle目录，如单测Bundle

    */
            
    // 主二进制
    if let url = Bundle.main.executableURL {
        let name = url.lastPathComponent
        if !name.isEmpty {
            frameworkNames.append(name)
        }
    }
    
    // Frameworks
    if let path = Bundle.main.privateFrameworksPath,
       let contents = try? FileManager.default.contentsOfDirectory(atPath: path) {
        for filePath in contents {
            frameworkNames.append((filePath as NSString).deletingPathExtension)
        }
    }

    // Plugins
    if let path = Bundle.main.builtInPlugInsPath,
       let contents = try? FileManager.default.contentsOfDirectory(atPath: path) {
        for filePath in contents {
            frameworkNames.append((filePath as NSString).deletingPathExtension)
        }
    }
    
    return loadMachOData(by: frameworkNames, segment: segment, section: section)
}

public func loadMachOData<T: MachODataConvertible>(by frameworkNames: [String],
                                                    segment: MachOSegment,
                                                    section: MachOSection) -> [T] {
    var results: [T] = []
    for name in frameworkNames {
        var size: UInt = 0
        guard let memory = getsectdatafromFramework(name,
                                                    segment.name,
                                                    section.name,
                                                    &size)
        else { continue }
        
        let stride = MemoryLayout<T.RawType>.stride
        let count = Int(size) / stride

        for i in 0..<count {
            let raw = UnsafeRawPointer(memory.advanced(by: i * stride))
            let value = raw.assumingMemoryBound(to: T.RawType.self).pointee
            results.append( T.convert(value) )
        }
    }
    
    return results

}

/**
 getsectdatafromFramework 内部的具体实现
 
 /*
  * This routine returns the a pointer to the data for the named section in the
  * named segment if it exist in the named Framework.  Also it returns the size
  * of the section data indirectly through the pointer size.  Otherwise it
  * returns zero for the pointer and the size.  The last component of the path
  * of the Framework is passed as FrameworkName.
  */
 void *
 getsectdatafromFramework(
 const char *FrameworkName,
 const char *segname,
 const char *sectname,
 unsigned long *size)
 {
     uint32_t i, n;
     uintptr_t vmaddr_slide;
 #ifndef __LP64__
     struct mach_header *mh;
     const struct section *s;
 #else /* defined(__LP64__) */
     struct mach_header_64 *mh;
     const struct section_64 *s;
 #endif /* defined(__LP64__) */
     char *name, *p;
         n = _dyld_image_count();
         for(i = 0; i < n ; i++){
             name = _dyld_get_image_name(i);
             p = strrchr(name, '/');
             if(p != NULL && p[1] != '\0')
                 name = p + 1;
             if(strcmp(name, FrameworkName) != 0)
                 continue;
             mh = _dyld_get_image_header(i);
             vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
 #ifndef __LP64__
             s = getsectbynamefromheader(mh, segname, sectname);
 #else /* defined(__LP64__) */
             s = getsectbynamefromheader_64(mh, segname, sectname);
 #endif /* defined(__LP64__) */
             if(s == NULL){
                 *size = 0;
                 return(NULL);
             }
             *size = s->size;
             return((void *)(s->addr + vmaddr_slide));
         }
         *size = 0;
         return(NULL);
 }

 */
