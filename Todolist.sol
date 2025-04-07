// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Todo{
    struct todo{
        string text;
        bool completed;
    }

    todo[] private  todos;

    function create(string calldata _text,bool falg) external {
        todos.push(todo({
            text:_text,
            completed:falg
        }));
    }

    function updateText(uint _index,string calldata _text) external {
        todos[_index].text = _text;//这种适合单个变量更新的时候，更节省gas

        // todo storage todoItem=todos[_index];
        // todoItem.text=_text;//这个适合多个变量更新的适合，更节省gas
    }

    function toggleCompleted(uint _index,bool falg) external {
        todos[_index].completed=falg;
    }

    function get(uint _index) external view returns (string memory ,bool){
        todo storage todoItem = todos[_index];
        return (todoItem.text,todoItem.completed);
    }
}