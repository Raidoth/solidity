
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract shop_task {
    int8 private count_task=0;
  struct info_task{
      string name;
      uint timestamp;
      bool isComplete;
  }
  mapping (int8 =>info_task) map_task;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
         require(msg.pubkey() == tvm.pubkey(), 102);
         tvm.accept();
         
         
    }
    modifier checkOwnerAndAccept() {
        require(msg.pubkey()==tvm.pubkey(), 102);
        tvm.accept();
        _;
    }
    function add_task(string name)public checkOwnerAndAccept{
        count_task++;
        map_task[count_task]=info_task(name,now,false);
      
    }
    function get_count_task()public checkOwnerAndAccept view returns(int8) {
        return count_task;
    }
    function get_description_task(int8 num) public checkOwnerAndAccept view returns(string,uint,bool){
            require(num!=0,104);
            require(num<=count_task,103);
            return (map_task[num].name,map_task[num].timestamp,map_task[num].isComplete);
        }
        function set_complete_task(int8 num) public checkOwnerAndAccept {
            require(num<=count_task,103);
            map_task[num].isComplete = true;
        }
        function delete_task(int8 num) public checkOwnerAndAccept{
            require(num<=count_task,103);
            delete map_task[num];
            count_task--;
            if(count_task>1&&num!=count_task){
                    for(int8 i = num+1;i<count_task;i++){
                        map_task[i-1]=map_task[i];
                    }
            }
            
        }
        function get_list_task()public checkOwnerAndAccept view returns(string[]){
           
            string [] task_list;
            for(int8 i = 1;i<=count_task;i++){
                task_list.push(map_task[i].name);

            }
            return (task_list);
        }
       
    }
    


