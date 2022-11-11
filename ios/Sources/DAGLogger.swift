/**
 Debug Logger for DataTrans RN Module
 */
final internal class DAGLogger{
    private let tag: String
    init(tag: String){
        self.tag = tag
    }
    
    func print(_ data: String){
        #if DEBUG
        Swift.print("[DEBUG] DAG \(tag): \(data)")
        #endif
    }
}
