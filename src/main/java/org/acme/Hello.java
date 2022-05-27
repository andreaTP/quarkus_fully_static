package org.acme;

import io.quarkus.runtime.annotations.QuarkusMain;

@QuarkusMain
public class Hello {

    public static void main(String[] args) {
        System.out.printf("Hello world!\n");
    }

}
