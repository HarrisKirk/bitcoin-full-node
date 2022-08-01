"""
Environment parameters.  Hard coded (for now)
"""
from enum import Enum, auto


class BtcEnvironment(str, Enum):
    DEV = "DEV"
    TEST = "TEST"
    PROD = "PROD"

    def get_help_msg():
        return "The bitcoin node environment (linode instance with volume)"


environments = {
    BtcEnvironment.DEV.value: {"version": "23.0", "chain": "test", "vol_size_gb": "50"},
    BtcEnvironment.TEST.value: {"version": "23.0", "chain": "test", "vol_size_gb": "50"},
    BtcEnvironment.PROD.value: {"version": "23.0", "chain": "main", "vol_size_gb": "500"},
}
