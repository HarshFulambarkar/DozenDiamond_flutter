import 'package:dozen_diamond/cash_allocation/models/ladder_creation_tickers_response.dart';
import '../../global/constants/currency_constants.dart';
import '../models/ladder_creation_tickers_response.dart'
    as ladder_creation_tickers_response;

class DummyUserStockAndLadderData {
  Future<LadderCreationTickerResponse> getDummyUserStockAndLadder() async {
    Data data;

    if (await getIsCountryUsaFromPreferences()) {
      data = Data(
          ladderCreationTickerList: [
            LadderCreationTickerList(
              ssId: 280,
              ssRegId: 721,
              ssTickerId: 3637,
              ssTicker: "TCS",
              ssCurrentPrice: "4551.00",
              ssExchange: "BSE",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            ),
            LadderCreationTickerList(
              ssId: 294,
              ssRegId: 721,
              ssTickerId: 53,
              ssTicker: "AARTIIND",
              ssCurrentPrice: "4551.00",
              ssExchange: "BSE",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            ),
            LadderCreationTickerList(
              ssId: 295,
              ssRegId: 721,
              ssTickerId: 4036,
              ssTicker: "WIPRO",
              ssCurrentPrice: "4551.00",
              ssExchange: "BSE",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            )
          ],
          accountCashForNewLadders: "1000000.00",
          accountExtraCashGenerated: "0.0",
          accountExtraCashLeft: "0.0",
          accountUnallocatedCash: "1000000.00");
    } else {
      data = Data(
          ladderCreationTickerList: [
            LadderCreationTickerList(
              ssId: 280,
              ssRegId: 721,
              ssTickerId: 3637,
              ssTicker: "MSFT",
              ssCurrentPrice: "430.59",
              ssExchange: "NASDAQ",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            ),
            LadderCreationTickerList(
              ssId: 294,
              ssRegId: 721,
              ssTickerId: 53,
              ssTicker: "GOOG",
              ssCurrentPrice: "158.37",
              ssExchange: "NASDAQ",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            ),
            LadderCreationTickerList(
              ssId: 295,
              ssRegId: 721,
              ssTickerId: 4036,
              ssTicker: "AMZN",
              ssCurrentPrice: "186.49",
              ssExchange: "NASDAQ",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            )
          ],
          accountCashForNewLadders: "1000000.00",
          accountExtraCashGenerated: "0.0",
          accountExtraCashLeft: "0.0",
          accountUnallocatedCash: "1000000.00");
    }

    LadderCreationTickerResponse? value = LadderCreationTickerResponse(
        status: true,
        message: "ladder creation tickers fetched successfully",
        data: data);

    return value;
  }

  Future<ladder_creation_tickers_response.LadderCreationTickerResponse>
      getDummyUserStockAndLadder2() async {
    ladder_creation_tickers_response.Data data;

    if (await getIsCountryUsaFromPreferences()) {
      data = ladder_creation_tickers_response.Data(
          ladderCreationTickerList: [
            ladder_creation_tickers_response.LadderCreationTickerList(
              ssId: 280,
              ssRegId: 721,
              ssTickerId: 3637,
              ssTicker: "TCS",
              ssCurrentPrice: "4551.00",
              ssExchange: "BSE",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            ),
            ladder_creation_tickers_response.LadderCreationTickerList(
              ssId: 294,
              ssRegId: 721,
              ssTickerId: 53,
              ssTicker: "AARTIIND",
              ssCurrentPrice: "4551.00",
              ssExchange: "BSE",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            ),
            ladder_creation_tickers_response.LadderCreationTickerList(
              ssId: 295,
              ssRegId: 721,
              ssTickerId: 4036,
              ssTicker: "WIPRO",
              ssCurrentPrice: "4551.00",
              ssExchange: "BSE",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            )
          ],
          accountCashForNewLadders: "1000000.00",
          accountExtraCashGenerated: "0.0",
          accountExtraCashLeft: "0.0",
          accountUnallocatedCash: "1000000.00");
    } else {
      data = ladder_creation_tickers_response.Data(
          ladderCreationTickerList: [
            ladder_creation_tickers_response.LadderCreationTickerList(
              ssId: 280,
              ssRegId: 721,
              ssTickerId: 3637,
              ssTicker: "MSFT",
              ssCurrentPrice: "430.59",
              ssExchange: "NASDAQ",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            ),
            ladder_creation_tickers_response.LadderCreationTickerList(
              ssId: 294,
              ssRegId: 721,
              ssTickerId: 53,
              ssTicker: "GOOG",
              ssCurrentPrice: "158.37",
              ssExchange: "NASDAQ",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            ),
            ladder_creation_tickers_response.LadderCreationTickerList(
              ssId: 295,
              ssRegId: 721,
              ssTickerId: 4036,
              ssTicker: "AMZN",
              ssCurrentPrice: "186.49",
              ssExchange: "NASDAQ",
              ssCashAllocated: "333333.33",
              ladderDetails: [],
            )
          ],
          accountCashForNewLadders: "1000000.00",
          accountExtraCashGenerated: "0.0",
          accountExtraCashLeft: "0.0",
          accountUnallocatedCash: "1000000.00");
    }

    ladder_creation_tickers_response.LadderCreationTickerResponse? value =
        ladder_creation_tickers_response.LadderCreationTickerResponse(
            status: true,
            message: "ladder creation tickers fetched successfully",
            data: data);

    return value;
  }
}
