// create a new grid with pieces on the first and last rows
let newGrid = _ =>
  Array.make_matrix(9, 9, Js.Null.return)->Belt.Array.mapWithIndex((row, columns) =>
    columns->Belt.Array.mapWithIndex((column, _) => {
      let key = Belt.Int.toString(row) ++ "-" ++ Belt.Int.toString(column)
      let piece = row === 0 ? Some(#White) : row === 8 ? Some(#Black) : None

      <Cell key row column piece />
    })
  )

@react.component
let make = () => {
  let (grid, setGrid) = React.useState(newGrid)
  // which color's turn is it
  let (currentColor, selectColor) = React.useState(_ => #White)
  // user may select a cell (or not)
  let (selectedCell: CurrentTurnContext.selectedCell, selectCell) = React.useState(_ => None)

  let movePiece: ((int, int), (int, int)) => unit = (prev, next) => {
    if prev == (4, 4) {
      // if a piece moves off of the center piece, the game is over so reset the grid
      setGrid(newGrid)
    } else {
      // remove the piece from the `prev` cell
      grid[fst(prev)][
        snd(prev)
      ] =
        <Cell
          key={Belt.Int.toString(fst(prev)) ++ "-" ++ Belt.Int.toString(snd(prev))}
          row={fst(prev)}
          column={snd(prev)}
          piece=None
        />

      // add the piece to the `prev` cell overwriting any current piece
      grid[fst(next)][
        snd(next)
      ] =
        <Cell
          key={Belt.Int.toString(fst(next)) ++ "-" ++ Belt.Int.toString(snd(next))}
          row={fst(next)}
          column={snd(next)}
          piece=Some(currentColor)
        />

      // set the current turn to the other color
      selectColor(prev => prev === #White ? #Black : #White)
    }
  }

  <CurrentTurnContext.Provider
    value={
      CurrentTurnContext.movePiece: movePiece,
      color: currentColor,
      selectedCell: selectedCell,
      selectCell: selectCell,
    }>
    <div className="mt5">
      {grid
      ->Belt.Array.mapWithIndex((row, columns) => {
        let key = Belt.Int.toString(row)
        <div key className="flex justify-center"> {React.array(columns)} </div>
      })
      ->React.array}
    </div>
  </CurrentTurnContext.Provider>
}
