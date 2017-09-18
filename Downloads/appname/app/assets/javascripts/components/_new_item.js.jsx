var NewItem= React.createClass({
    handleClick() {
        var name = document.getElementById("name").value;
        var description = document.getElementById("description").value;
        console.log('The name value is ' + name + 'the description value is ' + description);
            $.ajax({
                url: '/api/v1/items',
                type: 'POST',
                data: { item: { name: name, description: description } },
                success: (item) => {
                    this.props.handleSubmit(item);
                }
            });
        },
    render() {
        return (
            <div>
                <input id='name' placeholder='Enter the name of the item' />
                <input id='description' placeholder='Enter a description' />
                <button onClick={this.handleClick}>Submit</button>
            </div>
        )
    }
});
