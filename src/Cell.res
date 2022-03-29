@react.component
let make = (~row: int, ~column: int, ~piece: option<[#White | #Black]>) => {
  let turn = React.useContext(CurrentTurnContext.turn)
  let (hovered, hover) = React.useState(_ => false)

  // does this cell have a piece on it
  let hasPiece = switch piece {
  | Some(_) => true
  | _ => false
  }

  // is this cell the currently selected cell
  let selected = switch turn.selectedCell {
  | Some((x, y)) if x === row && y === column => true
  | _ => false
  }

  // if this cell does not have a piece of the same color on it
  // and it is a valid move from the currently selected cell
  let isValidDestinatoin = switch (piece, turn.selectedCell) {
  | (Some(color), _) if color === turn.color => false
  | (_, Some((x, y))) =>
    (x === row + 1 && (y === column + 2 || y === column - 2)) ||
    x === row + 2 && (y === column + 1 || y === column - 1) ||
    x === row - 1 && (y === column - 2 || y === column + 2) ||
    (x === row - 2 && (y === column - 1 || y === column + 1))
  | _ => false
  }

  let onMouseEvent = evt => {
    // when the mouse goes over this cell, set `hovered: true`
    // otherwise set `hovered: false`
    let type_ = evt->ReactEvent.Synthetic.type_
    let hovered = type_ === "mousenter" || type_ === "mouseover"

    hover(_ => hovered)
  }

  let onClick = evt => {
    if isValidDestinatoin {
      // if a piece can be moved here, move it
      turn.selectedCell->Belt.Option.forEach(coords => turn.movePiece(coords, (row, column)))
      // deselect the currently selected cell
      turn.selectCell(_ => None)
    } else if !selected && hasPiece && Some(turn.color) == piece {
      // if this cell isn't currently selected, has a cell on it, and it's our turn
      // select this cell
      turn.selectCell(_ => Some((row, column)))
    } else {
      turn.selectCell(_ => None)
    }

    evt->ReactEvent.Synthetic.stopPropagation
    evt->ReactEvent.Synthetic.preventDefault
  }

  let bgColor = switch (isValidDestinatoin, selected || hovered, row, column) {
  | (true, true, 4, 4) => "bg-green"
  | (true, true, _, _)
  | (true, _, 4, 4) => "bg-light-green"
  | (true, _, _, _) => "bg-washed-green"
  | (_, true, _, _) => "bg-washed-yellow"
  | (_, _, 4, 4) => "bg-light-silver"
  | (_, _, x, y) if mod(x + y, 2) === 0 => "bg-moon-gray"
  | _ => "bg-near-white"
  }

  let className =
    [
      "w3 h3 ba hide-child b--light-gray flex items-center justify-center",
      bgColor,
      column === 0 ? "" : " bl-0",
      row === 0 ? "" : " bt-0",
    ]->Js.Array2.joinWith(" ")

  <div
    onMouseLeave=onMouseEvent
    onMouseEnter=onMouseEvent
    onMouseOut=onMouseEvent
    onMouseOver=onMouseEvent
    onClick
    className>
    {piece->Belt.Option.mapWithDefault(React.null, color => <Piece color />)}
  </div>
}
