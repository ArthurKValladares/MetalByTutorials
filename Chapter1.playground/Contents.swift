import PlaygroundSupport
import MetalKit

// Renderer base structs
guard let device = MTLCreateSystemDefaultDevice() else {
  fatalError("GPU is not supported")
}
guard let commandQueue = device.makeCommandQueue() else {
    fatalError("Could not create command queue")
}

// View and frame
let frame = CGRect(x: 0, y: 0, width: 900, height: 900)
let view = MTKView(frame: frame, device: device)
view.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)

// Mesh
let allocator = MTKMeshBufferAllocator(device: device)
let mdlMesh = MDLMesh(sphereWithExtent: [0.75, 0.75, 0.75],
                      segments: [100, 100],
                      inwardNormals: false,
                      geometryType: .triangles,
                      allocator: allocator)
let mesh = try MTKMesh(mesh: mdlMesh, device: device)

// Shader
// TODO: read from file
let shader = """
#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertex_in [[stage_in]]) {
    return vertex_in.position;
}

fragment float4 fragment_main() {
    return float4(1, 0, 0, 1);
}
"""
let library = try device.makeLibrary(source: shader, options: nil)
let vertexFunction = library.makeFunction(name: "vertex_main")
let fragmentFunction = library.makeFunction(name: "fragment_main")