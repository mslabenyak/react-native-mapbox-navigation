/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from "react";
import {
  Platform,
  StyleSheet,
  Text,
  View,
  Button,
  PermissionsAndroid
} from "react-native";
import NavigationView from "./NavigationView";
import { NativeModules } from "react-native";

type Props = {};
export default class App extends Component<Props> {
  state = {
    granted: Platform.OS === "ios",
    fromLat: 34.028092,
    fromLong: -118.484868,
    toLat: 34.019444,
    toLong: -118.409259
  };

  componentDidMount() {
    if (!this.state.granted) {
      this.requestFineLocationPermission();
    }
  }

  async requestFineLocationPermission() {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
        {
          title: "ACCESS_FINE_LOCATION",
          message: "Mapbox navigation needs ACCESS_FINE_LOCATION"
        }
      );
      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        this.setState({ granted: true });
      } else {
        console.log("ACCESS_FINE_LOCATION permission denied");
      }
    } catch (err) {
      console.warn(err);
    }
  }

  render() {
    const { granted, fromLat, fromLong, toLat, toLong } = this.state;
    return (
      <View style={styles.container}>
        <View style={styles.subcontainer}>
          <Text style={styles.welcome}>
            Welcome to Mapbox Navigation for React Native
          </Text>
        </View>
        {granted && (
          <NavigationView
            style={styles.navigation}
            destination={{
              lat: toLat,
              long: toLong
            }}
            origin={{
              lat: fromLat,
              long: fromLong
            }}
          />
        )}
        <View style={styles.subcontainer}>
          <Text style={styles.welcome}>Another View !</Text>
          {Platform.OS === "android" && (
            <Button
              title={"Start Navigation - NativeModule"}
              onPress={() => {
                NativeModules.MapboxNavigation.navigate(
                  fromLat,
                  fromLong,
                  toLat,
                  toLong
                );
              }}
            />
          )}
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "stretch",
    backgroundColor: "whitesmoke"
  },
  subcontainer: {
    flex: 1,
    justifyContent: "center",
    backgroundColor: "whitesmoke"
  },
  welcome: {
    fontSize: 20,
    textAlign: "center",
    margin: 10
  },
  navigation: {
    backgroundColor: "gainsboro",
    flex: 1
  }
});
