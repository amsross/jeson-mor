switch ReactDOM.querySelector("#app") {
| Some(root) => ReactDOM.render(<Board />, root)
| None => ()
}
