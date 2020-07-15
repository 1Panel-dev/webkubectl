package token

import "time"

const (
	//DefaultExpiration never expire
	DefaultExpiration = 0
)

//TtyParameter kubectl tty param
type TtyParameter struct {
	Title string
	Arg   string
}

//Cache define token cache behive
type Cache interface {
	Get(token string) *TtyParameter
	Delete(token string) error
	Add(token string, param *TtyParameter, d time.Duration) error
}
