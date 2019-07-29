Sub stockdata()
    Dim WS As Worksheet

    For Each WS In ActiveWorkbook.Worksheets
    WS.Activate
        
        ' determine the Last Row
        lastrow = WS.Cells(Rows.Count, 1).End(xlUp).row
                      
     'create variables
      Dim ticker As String
      Dim volume  As Double
      Dim yearly_change As Double
      Dim percent_change As Double
      Dim open_price As Double
      Dim close_price As Double
   
        
     'set volume to 0
      volume = 0
      
      'set open price for first stock
      open_price = Cells(2, 3).Value
      
    ' keep track of the location for each ticker name in the summary table
      Dim row As Integer
      row = 2
            
       'set headers
      Range("I1").Value = "Ticker"
      Range("L1").Value = "Total Stock Volume"
      Range("J1").Value = "Yearly Change"
      Range("K1").Value = "Percent Change"
      
      'set formatting
       WS.Columns("K").NumberFormat = "0.00%"

        'Loop through columns 1 and 7
        For i = 2 To lastrow
                    
            ' Check if we are still within the ticker name, if it is not...
             
              If Cells(i + 1, 1).Value <> Cells(i, 1).Value Then
                
                  'get ticker name and set cell value to ticker value
                   ticker = Cells(i, 1).Value
                    Cells(row, 9).Value = ticker
                    
                    ' add total volume
                    volume = volume + Cells(i, 7).Value
                    Cells(row, 12).Value = volume
                    
                    ' get close price
                    close_price = Cells(i, 6).Value
                    
                     'calculate yearly change
                    yearly_change = close_price - open_price
                    
                   'print yearly change in summary table
                   Cells(row, 10).Value = yearly_change
                   
                   'calculate percent_change and print in the summary table
                   'We can't calculate a percentage when open price is zero (PLNT)
                    If (open_price = 0 And close_price = 0) Then
                        percent_change = 0
                         ElseIf (open_price = 0 And close_price <> 0) Then
                        percent_change = 1
                         Else
                            percent_change = (yearly_change / open_price)
                            Cells(row, 11).Value = percent_change
                        End If
            
                   
                   'Apply conditional formatting that will highlight positive change in green and negative change in red
                        If yearly_change >= 0 Then
                            Cells(row, 10).Interior.ColorIndex = 4
                            Else
                            Cells(row, 10).Interior.ColorIndex = 3
                
                        End If
           
                    'get open price for next year
                     open_price = Cells(i + 1, 3).Value
                    
                    ' Add one to the summary table row
                    row = row + 1
                    
                    'reset volume total
                    volume = 0
                Else
                    volume = volume + Cells(i, 7).Value
                End If
                
        Next i
    Next
End Sub
