package token

import "time"

const (
	//DefaultExpiration never expire
	DefaultExpiration = 5 * time.Minute
)

//TtyParameter kubectl tty param
type TtyParameter struct {
	Title string
	Arg   string
}

//interface that defines token cache behavior
type Cache interface {
	Get(token string) *TtyParameter
	Delete(token string) error
	Add(token string, param *TtyParameter, d time.Duration) error
}
