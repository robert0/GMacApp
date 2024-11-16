//
//  Sample4D.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class Sample4D: Sample3D {
    public var time: Int64 = 0

    /**
     *
     * @return
     */
    init(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        super.init(x, y, z)
        self.time = time
    }

    /**
     *
     * @return
     */
    public func getTime() -> Int64 {
        return self.time
    }
}
