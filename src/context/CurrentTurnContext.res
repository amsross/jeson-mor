type rec t = {
  movePiece: (coords, coords) => unit,
  color: [#White | #Black],
  selectedCell: selectedCell,
  selectCell: (selectedCell => selectedCell) => unit,
}
and selectedCell = option<coords>
and coords = (int, int)

let turn: React.Context.t<t> = React.createContext({
  movePiece: (_, _) => (),
  color: #White,
  selectedCell: None,
  selectCell: _ => (),
})

module Provider = {
  let provider = React.Context.provider(turn)

  @react.component
  let make = (~value, ~children) => {
    React.createElement(provider, {"value": value, "children": children})
  }
}
